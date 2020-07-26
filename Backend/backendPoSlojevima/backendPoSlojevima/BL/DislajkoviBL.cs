using System;
using System.Collections.Generic;
using System.Linq;
using System.Threading.Tasks;
using backendPoSlojevima.BL.Interfaces;
using backendPoSlojevima.DAL.Interfaces;
using backendPoSlojevima.Models;

namespace backendPoSlojevima.BL
{
    public class DislajkoviBL : IDislajkoviBL
    {
        private readonly IDislajkoviDAL _IDislajkoviDAL;
        private readonly List<Dislajkovi> dislajkovi;
        private readonly IKorisnikBL _IKorisnikBL;

        public DislajkoviBL (IDislajkoviDAL IDislajkoviDAL, IKorisnikBL IKorisnikBL)
        {
            _IDislajkoviDAL = IDislajkoviDAL;
            _IKorisnikBL = IKorisnikBL;
            dislajkovi = _IDislajkoviDAL.getAllDislajkovi();
        }

        public void deleteDislajkoveByIdKorisnika(long idKorisnika)
        {
            List<Dislajkovi> listaDislajkova = getDislajkoveByKorisnikId(idKorisnika);
          //  foreach(var dislajk in listaDislajkova)
            {
                _IDislajkoviDAL.deleteDislajk(listaDislajkova);
            }
        }

        public void deleteDislajkoveByIdObjave(long idObjave)
        {
            List<Dislajkovi> listaDislajkova = getDislajkoveByIdObjave(idObjave);
           // foreach (var dislajk in listaDislajkova)
            {
                _IDislajkoviDAL.deleteDislajk(listaDislajkova);
            }
        }

        public List<Dislajkovi> getAllDislajkovi()
        {
            return _IDislajkoviDAL.getAllDislajkovi();
        }

        public long getBrojDislajkovaByIdObjave(long idObjave)
        {
            var pokupiDislajkove = dislajkovi.Where(d => d.ObjaveID == idObjave);
            long brojDisljakova = pokupiDislajkove.Count();
            return brojDisljakova;
        }

        public int getDislajkByKorisnikId(long idKorisnika, long idObjave)
        {
            var check = dislajkovi.FirstOrDefault(l => l.ObjaveID == idObjave && l.KorisnikID == idKorisnika);
            if (check != null) return 1;
            else
            {
                return 0;
            }
        }

        public List<Dislajkovi> getDislajkoveByIdObjave(long idObjave)
        {
            return dislajkovi.Where(d => d.ObjaveID == idObjave).ToList();
        }

        public List<Dislajkovi> getDislajkoveByKorisnikId(long idKorisnika)
        {
            return dislajkovi.Where(d => d. KorisnikID == idKorisnika).ToList();
        }

        public List<Korisnik> getKorisnikeKojiDislajkujuByIdObjave(long idObjave)
        {
            List<Korisnik> korisnici = new List<Korisnik>();
            var korisniciKojiSuLajkovali = dislajkovi.Where(o => o.ObjaveID == idObjave);
            foreach (var korisnik in korisniciKojiSuLajkovali)
            {
                Korisnik kor = _IKorisnikBL.getKorisnikaById(korisnik.KorisnikID);
                korisnici.Add(kor);
            }
            return korisnici;
        }

        public void saveDislajk(Dislajkovi data)
        {
            _IDislajkoviDAL.saveDislajk(data);
        }
    }
}
