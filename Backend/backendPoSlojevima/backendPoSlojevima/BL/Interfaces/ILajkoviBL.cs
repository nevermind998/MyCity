using backendPoSlojevima.Models;
using System;
using System.Collections.Generic;
using System.Linq;
using System.Threading.Tasks;

namespace backendPoSlojevima.BL.Interfaces
{
    public interface ILajkoviBL
    {
        List<Lajkovi> getAllLajkovi();
        public void saveLajk(Lajkovi data);
        void deleteLajkoveByIdObjave(long idObjave);
        void deleteLajkoveByIdKorisnika(long idKorisnika);
        List<Lajkovi> getLajkoveByIdObjave(long idObjave);
        long getBrojLajkovaByIdObjave(long data);
        List<Lajkovi> getLajkoveByKorisnikId(long data);
        List<Korisnik> getKorisnikeKojiLajkujuByIdObjave(long objava);
        List<Objave> getNajpopularnijeObjave();
        int getLajkByKorisnikId(long idKorisnika, long idObjave);
    }
}
