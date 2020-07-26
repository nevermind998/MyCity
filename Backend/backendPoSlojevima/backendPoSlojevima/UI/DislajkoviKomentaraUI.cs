using System;
using System.Collections.Generic;
using System.Linq;
using System.Threading.Tasks;
using backendPoSlojevima.BL.Interfaces;
using backendPoSlojevima.Models;
using backendPoSlojevima.UI.Interfaces;

namespace backendPoSlojevima.UI
{
    public class DislajkoviKomentaraUI : IDislajkoviKomentaraUI
    {
        private readonly IDislajkoviKomentaraBL _IDislajkoviKomentaraBL;

        public DislajkoviKomentaraUI(IDislajkoviKomentaraBL IDislajkoviKomentaraBL)
        {
            _IDislajkoviKomentaraBL = IDislajkoviKomentaraBL;
        }

        public void deleteDislajkoveKomentaraByIdKomentara(long idKomentara)
        {
            _IDislajkoviKomentaraBL.deleteDislajkoveKomentaraByIdKomentara(idKomentara);
        }

        public void deleteDislajkoveKomentaraByIdKorisnika(long idKorisnika)
        {
            _IDislajkoviKomentaraBL.deleteDislajkoveKomentaraByIdKorisnika(idKorisnika);
        }

        public List<DislajkoviKomentari> getAllDislajkovi()
        {
            return _IDislajkoviKomentaraBL.getAllDislajkovi();
        }

        public long getBrojDislajkovaByIdKomentara(long idKomentara)
        {
            return _IDislajkoviKomentaraBL.getBrojDislajkovaByIdKomentara(idKomentara);
        }

        public List<DislajkoviKomentari> getDisajkoveKomentaraByIdKomentara(long idKomentara)
        {
            return  _IDislajkoviKomentaraBL.getDisajkoveKomentaraByIdKomentara(idKomentara);
        }

        public int getDislajkKomentaraByIdKorisnika(long idKorisnika, long idKomentara)
        {
            return _IDislajkoviKomentaraBL.getDislajkKomentaraByIdKorisnika(idKorisnika, idKomentara);
        }

        public List<DislajkoviKomentari> getDislajkoveKomentaraByKorisnikId(PrihvatanjeIdKorisnika korisnik)
        {
            return _IDislajkoviKomentaraBL.getDislajkoveKomentaraByKorisnikId(korisnik.idKorisnika);
        }

        public List<Korisnik> getKorisnikeKojiDislajkujuByIdKomentara(long idKomentara)
        {
            return _IDislajkoviKomentaraBL.getKorisnikeKojiDislajkujuByIdKomentara(idKomentara);
        }

        public void saveDislajk(DislajkoviKomentari data)
        {
            _IDislajkoviKomentaraBL.saveDislajk(data);
        }
    }
}
