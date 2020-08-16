using System;
using System.Collections.Generic;
using System.Linq;
using System.Threading.Tasks;
using backendPoSlojevima.BL.Interfaces;
using backendPoSlojevima.DAL.Interfaces;
using backendPoSlojevima.Models;

namespace backendPoSlojevima.BL
{
    public class DislajkoviKomentaraBL : IDislajkoviKomentaraBL
    {
        private readonly IDislajkoviKomentaraDAL _IDislajkoviKomentaraDAL;
        private readonly IKorisnikBL _IKorisnikBL;
        private readonly List<DislajkoviKomentari> dislajkoviKomentara;

        public DislajkoviKomentaraBL(IDislajkoviKomentaraDAL IDislajkoviKomentaraDAL, IKorisnikBL IKorisnikBL)
        {
            _IDislajkoviKomentaraDAL = IDislajkoviKomentaraDAL;
            _IKorisnikBL = IKorisnikBL;
            dislajkoviKomentara = _IDislajkoviKomentaraDAL.getAllDislajkovi();

        }

        public void deleteDislajkoveKomentaraByIdKomentara(long idKomentara)
        {
            List<DislajkoviKomentari> listaDislajkova = getDisajkoveKomentaraByIdKomentara(idKomentara);
            _IDislajkoviKomentaraDAL.deleteDislajkKomentara(listaDislajkova);
        }

        public void deleteDislajkoveKomentaraByIdKorisnika(long idKorisnika)
        {
            List<DislajkoviKomentari> listaDislajkova = getDislajkoveKomentaraByKorisnikId(idKorisnika);
             _IDislajkoviKomentaraDAL.deleteDislajkKomentara(listaDislajkova);
        }

        public List<DislajkoviKomentari> getAllDislajkovi()
        {
            return _IDislajkoviKomentaraDAL.getAllDislajkovi();
        }

        public long getBrojDislajkovaByIdKomentara(long idKomentara)
        {
            long broj = dislajkoviKomentara.Where(d => d.KomentarID == idKomentara).Count();
            return broj;
        }

        public List<DislajkoviKomentari> getDisajkoveKomentaraByIdKomentara(long idKometara)
        {
            return dislajkoviKomentara.Where(d => d.KomentarID == idKometara).ToList();
        }

        public int getDislajkKomentaraByIdKorisnika(long idKorisnika, long idKomentara)
        {
            return _IDislajkoviKomentaraDAL.getDislajkKomentaraByIdKorisnika(idKorisnika, idKomentara);
        }

        public List<DislajkoviKomentari> getDislajkoveKomentaraByKorisnikId(long idKorisnika)
        {
            return dislajkoviKomentara.Where(d => d.KorisnikID == idKorisnika).ToList();
        }

        public List<Korisnik> getKorisnikeKojiDislajkujuByIdKomentara(long idKomentara)
        {
            List<Korisnik> korisnici = new List<Korisnik>();
            var korisniciKojiSuLajkovali = dislajkoviKomentara.Where(o => o.KomentarID == idKomentara);
            foreach (var korisnik in korisniciKojiSuLajkovali)
            {
                Korisnik kor = _IKorisnikBL.getKorisnikaById(korisnik.KorisnikID);
                korisnici.Add(kor);
            }
            return korisnici;
        }

        public void saveDislajk(DislajkoviKomentari data)
        {
            _IDislajkoviKomentaraDAL.saveDislajk(data);
        }
    }
}